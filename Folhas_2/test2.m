corners1 =  detectKAZEFeatures(I1);
cornersS1 = corners1.selectStrongest(10)
 figure; imshow(I1); hold on; plot(cornersS1);
 
 corners2 =  detectKAZEFeatures(I2);
cornersS2 = corners2.selectStrongest(10)
 figure; imshow(I2); hold on; plot(cornersS2);