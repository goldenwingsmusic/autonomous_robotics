function [h] = move( h,l,r,distance )
    
    steps = abs(distance/0.13);    
    starting_value = kGetEncoders(h);
    encoder_value = 0;
    
    while abs(encoder_value) <= steps
        kSetSpeed(h,l,r);
        encoder_value = kGetEncoders(h)-starting_value;
    end
    kStop(h);
end

