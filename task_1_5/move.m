function [stopped] = move( h,l,r,distance )

global distances;
global prev_encoders;
stopped = 0;    
steps = abs(distance/0.13); 
        
kSetEncoders(h,0,0);
kSetSpeed(h,l,r);
        
while kGetEncoders(h) <= steps        
    
    updateOdometry(h);    
    readDistances(h);
    for i = 1 : 8            
          if distances(i) <= 2
              stopped =1;
              break;
          end            
    end
      if stopped == 1
           break;
      end
end
    kStop(h);
    kSetEncoders(h,0,0);
end