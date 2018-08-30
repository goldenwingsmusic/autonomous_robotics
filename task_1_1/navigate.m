function [h] = navigate(h, points, velocity,prevangle )

prev_angle = 0;
[m,n] = size(points);

for i = 1:m-1
    x = points(i+1,1)-points(i,1);
    y = points(i+1,2)-points(i,2);
    
    distance=abs(sqrt(x^2+y^2));
    
    angle = atan2(y,x)-prevangle;
    
    rotate(h,160,angle);
    stopped = move(h,velocity,velocity,distance);
    if stopped == 1
        break;
    end
    
  
    prev_angle = angle;
    
end