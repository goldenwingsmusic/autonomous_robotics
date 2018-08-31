function [h] = rotate( h,velocity,radians ) 

stopped = 0;

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
    
    while kGetEncoders(h) <= steps                
        updateOdometry(h);
    end    
    kStop(h);
end