#include <Rcpp.h>
#include <algorithm>
#include <map>

using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix calculate_distances_rcpp(NumericMatrix train, NumericMatrix test, String dist) {
  int n_train = train.nrow(), n_test = test.nrow(), n_features = train.ncol();
  NumericMatrix distances(n_train, n_test);
  
  for (int i = 0; i < n_test; i++) {
    for (int j = 0; j < n_train; j++) {
      double sum = 0.0;
      for (int k = 0; k < n_features; k++) {
        double diff = train(j, k) - test(i, k);
        sum += (dist == "sse") ? diff * diff : std::abs(diff);
      }
      distances(j, i) = sum;
    }
  }
  return distances;
}

// [[Rcpp::export]]
StringVector knn_predict_rcpp(NumericMatrix train, NumericMatrix test, StringVector classes, int k, String dist) {
  int n_test = test.nrow();
  StringVector predictions(n_test);
  NumericMatrix distances = calculate_distances_rcpp(train, test, dist);
  
  for (int i = 0; i < n_test; i++) {
    NumericVector instance_dists = distances(_, i);
    std::vector<int> indices(instance_dists.size());
    for (int j = 0; j < indices.size(); j++) indices[j] = j;
    
    std::partial_sort(indices.begin(), indices.begin() + k, indices.end(),
                      [&](int a, int b) { return instance_dists[a] < instance_dists[b]; });
    
    std::map<std::string, int> class_counts;
    for (int j = 0; j < k; j++) {
      std::string cls = as<std::string>(classes[indices[j]]);
      class_counts[cls]++;
    }
    
    std::string best_class;
    int max_count = -1;
    for (const auto& pair : class_counts) {
      if (pair.second > max_count) {
        max_count = pair.second;
        best_class = pair.first;
      }
    }
    predictions[i] = best_class;
  }
  return predictions;
}