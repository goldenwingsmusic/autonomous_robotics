function kBraitenberg2(ref,ir_steigung,ir_y_achsen_abschnitt,ir_kreuz)
global RUN

% if (nargin>4), IR_Sensor=1; end

objekt_sensor=zeros(8,1);

objekt_faktor=70;%max-wert 10 * 8mm/s
objekt_offset=1; %default speed is 5*8mm/s


RUN=1;
while RUN==1
    %fear of walls
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Auslesen der IR-Sensoren %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Wertebereich 0-1023 -> 1023: nah ->0: fern, nur 1,2,5,6
    pause(0.1)
    objekt_sensor=kProximity(ref);
    %springt aus der schleife
    if (objekt_sensor(8)>800)
      RUN=0;
    end;
    % Mittelwert linke IR-Sensoren
    objekt_sensor_links=mean(objekt_sensor(1:2))/objekt_faktor;
    % Mittelwert rechte IR-Sensoren
    objekt_sensor_rechts=mean(objekt_sensor(5:6))/objekt_faktor;
    display([objekt_sensor_links objekt_sensor_rechts])

    % Transferfunktion Sensoren -> Aktuatoren
    transfer_fkt_objekt_links = ir_steigung * objekt_sensor_links + ir_y_achsen_abschnitt;
    transfer_fkt_objekt_rechts = ir_steigung * objekt_sensor_rechts + ir_y_achsen_abschnitt;
    display([transfer_fkt_objekt_links transfer_fkt_objekt_rechts]);

    %%%%%%%%%%%%%%
    % Aktuatoren %
    %%%%%%%%%%%%%%
    if (ir_kreuz==0) % ungekreuzte Uebertragung
        % Motor links
        ir_speed(1) = transfer_fkt_objekt_links;	       
        % Motor rechts
        ir_speed(2) = transfer_fkt_objekt_rechts;
    else
        % Motor links
        ir_speed(1) = transfer_fkt_objekt_rechts;	       
        % Motor rechts
        ir_speed(2) = transfer_fkt_objekt_links;    
    end;

    speed(1) =  ir_speed(1)
    speed(2) =  ir_speed(2)
    kSetSpeed(ref,speed(1),speed(2));		% write the speed
end % while RUN=1

kSetSpeed(ref,0,0);
