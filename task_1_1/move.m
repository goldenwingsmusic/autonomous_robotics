function [h] = move( h,l,r,distance )
    
    steps = abs(distance/0.13);    
    kSetEncoders(h,0,0);
    kSetSpeed(h,l,r);
    while abs(kGetEncoders(h)) <= steps        
        plotSensors(h);
    end
    kStop(h);
end