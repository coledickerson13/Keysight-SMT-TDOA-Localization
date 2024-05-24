% Define the filename
filename = '3.28.25.9.9MHz.csv';
%Make sure to open CSV file and delete any spaces between column headings

% Read the data from the CSV file
data = readtable(filename);

%If a location estimate is not generated, lat and long = 0. The following
%line parses out these values.
rows_to_delete = data.Latitude < 1;
data(rows_to_delete, :) = [];

%reinitialize data table variables
Measurement_ID = data.MeasID;
Algorithm = data.Algorithm;
Center_Frequency = data.CenterFrequency;
Sample_Rate = data.SampleRate;
Number_of_Samples = data.NumSamples;
Latitude = data.Latitude;
Longitude = data.Longitude;
Elevation = data.Elevation;
Rho = data.RHO;
CEP = data.CEP;
Total_Sensors = data.TotalSensors;
Valid_Sensors = data.ValidSensors;
Overloaded_Sensors = data.OverloadedSensors;
Sensor_Names = data.SensorNames;
Time = data.Time;
Comment = data.Comment;

%real coordinates for LW1
LW1lat = 35.72750947;
LW1long = -78.69595810;

%real coordinates for LW2 - one of three towers used to generate
%localization estimate
LW2lat = 35.72821305;
LW2long = -78.70090823;

%real coordinates for LW3 - one of three towers used to generate
%localization estimate
LW3lat = 35.72491205;
LW3long = -78.69190014;

%real coordinates for LW4 - one of three towers used to generate
%localization estimate
LW4lat = 35.73318358;
LW4long = -78.6983642;

%real coordinates for LW5
% LW5lat = 35.74294142;
% LW5long = -78.69962993;

% Plot on map using Mapping Toolbox
figure;
geoplot(Latitude, Longitude, 'bo');
title('Keysight Sensor Management Tool TDOA Localization of AERPAW LW1');
hold on;
geoplot(LW1lat, LW1long, 'r^', 'MarkerSize', 10); %LW1
geoplot(LW2lat, LW2long, 'g^', 'MarkerSize', 10); %LW2
geoplot(LW3lat, LW3long, 'b^', 'MarkerSize', 10); %LW3
geoplot(LW4lat, LW4long, 'm^', 'MarkerSize', 10); %LW4
legend('TDOA Estimated TX Coordinates', 'AERPAW LW1', 'AERPAW LW2', 'AERPAW LW3', 'AERPAW LW4')
hold off;

%distance between LW1 and estimated coordinate points in meters
%(localization error)
localizationerror = deg2km(distance(LW1lat, LW1long, Latitude, Longitude))*1000;

%average localization error
average_error = mean(localizationerror);

%normalize the first time index to 0
normalized_time = Time - Time(1);

%create a new figure for the second plot
figure;

%plot localization error against time
plot(normalized_time, localizationerror, 'bo-');
title('SMT TDOA Localization Error vs. Time')
xlabel('Time (Hours:Minutes:Seconds)')
ylabel('Localization Error (meters)')

