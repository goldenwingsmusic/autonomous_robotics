function [didSwitch] = randomMovement(h)

global curInterval
global timeStamp
global curCommandCode

didSwitch= 0;

if(isempty(timeStamp))
    elapsedTime = 0;
else
    elapsedTime = toc(timeStamp);
end


if (isempty(curInterval) || elapsedTime > curInterval )
    curTime = clock;
    seed = curTime(6);
    rng(seed);
    
    timeIntervals = [1.5];
    
    straightCommands = [400,400;
    500,500;
    600,600;];
    
    circularCommands = [300,-300;
    -300,300;
    -600,600;
    600,-600;];
    
    arcCommands = [300,700;
    700,300;
    400,600;
    600,400];

    
    indexTime = randi([1 length(timeIntervals)]);
    curInterval = timeIntervals(indexTime);  
    
    if(isempty(curCommandCode))
        curCommandCode = randi([1 3]);
    end
    
    
    
    if (curCommandCode == 1)
        indexCommand = randi([1 length(straightCommands)]);
        curCommand  = straightCommands(indexCommand,:);
        curCommandCode = 2;
    elseif (curCommandCode == 2)
            indexCommand = randi([1 length(circularCommands)]);
            curCommand  = circularCommands(indexCommand,:);
            possibleCodes = [1 3];
            curCommandCode = possibleCodes(randi([1 2]));
    elseif(curCommandCode == 3)
            indexCommand = randi([1 length(arcCommands)]);
            curCommand  = arcCommands(indexCommand,:);
            curCommandCode = 2;
    end
    
   
    timeStamp = tic;
    kSetSpeed(h,curCommand(1),curCommand(2));
    didSwitch = 1;
end


end