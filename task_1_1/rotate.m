function [h] = rotate( h,velocity,radians ) 
    
if radians < 0
    right_velocity  = -velocity;
    left_velocity   = velocity;
else
    right_velocity  = velocity;
    left_velocity   = -velocity;
end

    steps = abs(((radians)*(26.5))/0.13);
    kSetEncoders(h,0,0);
    
    kSetSpeed(h,left_velocity,right_velocity);
    
    while abs(kGetEncoders(h)) <= steps
        
    end
    kStop(h);
end