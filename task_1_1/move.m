function [stopped] = move( h,l,r,distance )
    stopped = 0;
    steps = abs(distance/0.13);    
    kSetEncoders(h,0,0);
    kSetSpeed(h,l,r);
    while abs(kGetEncoders(h)) <= steps        
        distances = readDistances(h);
        for i = 1 : 8            
            if distances(i) <= 2
                stopped =1;
                break;
            end            
        end
        if stopped == 1
                break;
        end
        plotSensors(distances);
    end
    kStop(h);
end