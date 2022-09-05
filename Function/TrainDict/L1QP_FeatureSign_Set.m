function [S] = L1QP_FeatureSign_Set(X, B, Sigma, beta, gamma, t, num_trials)

[~, nSmp] = size(X);
nBases = size(B, 2);

% sparse codes of the features
S = sparse(nBases, nSmp);

A = B'*B + 2*beta*Sigma;

f = waitbar(0,['Dictionary Training Epoch: ' num2str(t) '/' num2str(num_trials)]);
for ii = 1:nSmp
    waitbar(ii/nSmp,f);
    b = -B'*X(:, ii);
    S(:, ii) = L1QP_FeatureSign_yang(gamma, A, b);
end
close(f)
end