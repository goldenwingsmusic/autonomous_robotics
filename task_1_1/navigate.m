function [h] = navigate(h, points, velocity )

prev_angle = 0;
[m,n] = size(points);

for i = 1:m-1
    x = points(i+1,1)-points(i,1);
    y = points(i+1,2)-points(i,2);
    
    distance=sqrt(x^2+y^2);
    
    prev_angle
    angle = atan2d(y,x);
    
    h = rotate(h,160,-prev_angle);
    h = rotate(h,160,angle);
    h = move(h,velocity,velocity,distance);
    
  
    prev_angle = angle;
    
end

