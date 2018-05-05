function imgHDR = constructHDR(images, g, ln_t, w, type)

img_i = images+1;
ln_t = reshape(ln_t, [1,1,length(ln_t)]);

if strcmp(type, 'modified')
    weight_sums = sum(w(img_i),3);
    ln_E = sum(((w(img_i)./weight_sums).*g(img_i))-ln_t, 3);
else
    ln_E = sum(w(img_i).*(g(img_i)-ln_t), 3)./sum(w(img_i),3);
end


imgHDR = exp(ln_E);