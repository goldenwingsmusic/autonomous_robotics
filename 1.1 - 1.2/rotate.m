function [h] = rotate( h,velocity,radians ) 

disp('rotating...');
    
if radians < 0
    right_velocity  = -velocity;
    left_velocity   = velocity;
else
    right_velocity  = velocity;
    left_velocity   = -velocity;
end

    steps = abs(((radians*(pi/180))*(26.5))/0.13);
    starting_value = kGetEncoders(h);
    encoder_value = 0;
    
    while encoder_value <= steps
        kSetSpeed(h,left_velocity,right_velocity);
        encoder_value = kGetEncoders(h)-starting_value;
    end
    kStop(h);
end

