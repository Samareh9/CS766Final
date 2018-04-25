function imgHDR = constructHDR(images, g, ln_t, w)

img_i = images+1;
ln_t = reshape(ln_t, [1,1,length(ln_t)]);
ln_E = sum(w(img_i).*(g(img_i)-ln_t), 3)./sum(w(img_i),3);



imgHDR = exp(ln_E);