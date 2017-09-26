function pcaScore = PCAscore(X)
  [COEFF,SCORE, latent,tsquare, explained] = princomp(X,'Centered',false);
  SelectNum = cumsum(latent)./sum(latent);
  index = find(SelectNum >= 0.85);
  ForwardNum = index(1);
  pcaScore = SCORE(:,1:ForwardNum);
end
