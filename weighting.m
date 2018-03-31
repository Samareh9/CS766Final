function weight = weighting()
weight = [1:1:256];
weight = min(weight, 256-weight);