%Reading in data from .csv file
% Define the filename
filename = 'updated_100m5MHz7.15.24.csv';
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
GTLongitude = data.GTLongitude;
GTLatitude = data.GTLatitude;
GTAltitude = data.GTAltitude;
%% First plot - 3D UAV Trajectory 

% Create a 3D plot of the UAV's trajectory
figure;
plot3(GTLongitude, GTLatitude, GTAltitude, '-o', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerFaceColor', 'b');
grid on;
xlabel('Longitude');
ylabel('Latitude');
zlabel('Altitude (m)');
title('3D Trajectory of UAV');

% Annotate the start and end points
hold on;
plot3(GTLongitude(1), GTLatitude(1), GTAltitude(1), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
plot3(GTLongitude(end), GTLatitude(end), GTAltitude(end), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;
%% Second Plot - 2D Estimated v. Ground Truth Coordinates

% Coordinates of towers
LW1lat = 35.72750947;
LW1long = -78.69595810;

LW2lat = 35.72821305;
LW2long = -78.70090823;

LW3lat = 35.72491205;
LW3long = -78.69190014;

LW4lat = 35.73318358;
LW4long = -78.6983642;

LW5lat = 35.74294142;
LW5long = -78.69962993;

% Create a new plot
figure;

% Plot the estimated coordinates
geoplot(Latitude, Longitude, 'bo', 'MarkerSize', 8, 'DisplayName', 'Estimated Coordinates');
hold on;

% Plot the ground truth coordinates
geoplot(GTLatitude, GTLongitude, 'rx', 'MarkerSize', 8, 'DisplayName', 'Ground Truth Coordinates');

% Plot tower coordinates
geoplot([LW1lat; LW2lat; LW3lat; LW4lat; LW5lat], [LW1long; LW2long; LW3long; LW4long; LW5long], 'g^', 'MarkerSize', 10, 'DisplayName', 'Towers');

% Add labels, legend, and title
title('Estimated vs Ground Truth Coordinates with Tower Locations');
legend('Location', 'Best');
grid on;
hold off;
%% Third Plot - Error vs. Altitude

wgs84 = wgs84Ellipsoid("meter");
distance_error = distance(GTLatitude, GTLongitude, Latitude, Longitude, wgs84);
disp(distance_error);

% Plot error against altitude
figure;
scatter(GTAltitude, distance_error, 'filled');
xlabel('Altitude (m)');
ylabel('Distance Error (m)');
title('Distance Error vs Altitude');
grid on;

%% Fourth Plot - Error v Time
% Plot distance error against time
figure;
plot(Time, distance_error, 'bo-', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Distance Error (m)');
title('Distance Error vs Time');
grid on;

%% Fifth Plot - Altitude v Time

% Plot altitude against time
figure;
plot(Time, GTAltitude, 'b-', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Altitude (m)');
title('Altitude vs Time');
grid on;

%% Sixth Plot - 3D Plot UAV Trajectory with color coded coordinates
figure;
hold on;

% Plot points with distance error less than 100 meters
idx_green = distance_error < 100;
plot3(GTLongitude(idx_green), GTLatitude(idx_green), GTAltitude(idx_green), 'go', 'MarkerSize', 8, 'DisplayName', 'Distance Error < 100m');

% Plot points with distance error greater than or equal to 100 meters
idx_red = distance_error >= 100;
plot3(GTLongitude(idx_red), GTLatitude(idx_red), GTAltitude(idx_red), 'ro', 'MarkerSize', 8, 'DisplayName', 'Distance Error >= 100m');

hold off;

xlabel('Longitude');
ylabel('Latitude');
zlabel('Altitude (m)');
title('3D Trajectory of UAV');
grid on;

% Add legend
legend('Location', 'best');

%% Seventh Plot - Ground Truth Coordinates Color Coded

% Define colors based on distance error
colors = cell(size(distance_error));
for i = 1:length(distance_error)
    if distance_error(i) >= 100
        colors{i} = 'r';
    else
        colors{i} = 'g';
    end
end

% Find indices of points with distance error >= 100 meters and < 100 meters
idx_error_ge_100 = distance_error >= 100;
idx_error_lt_100 = distance_error < 100;

% Plot points with distance error >= 100 meters in red
figure;
geoplot(GTLatitude(idx_error_ge_100), GTLongitude(idx_error_ge_100), 'ro', 'MarkerSize', 8, 'DisplayName', 'Distance Error >= 100m');
hold on;

% Plot points with distance error < 100 meters in green
geoplot(GTLatitude(idx_error_lt_100), GTLongitude(idx_error_lt_100), 'go', 'MarkerSize', 8, 'DisplayName', 'Distance Error < 100m');

% Plot tower locations
geoplot([LW1lat; LW2lat; LW3lat; LW4lat; LW5lat], [LW1long; LW2long; LW3long; LW4long; LW5long], 'b^', 'MarkerSize', 10, 'DisplayName', 'Towers');

% Add labels, legend, and title
title('Ground Truth Coordinates with Distance Error Color Code');
legend('Location', 'Best');
grid on;

%% 
average_distance_error = mean(distance_error);
fprintf('Average distance error: %.2f meters\n', average_distance_error);

% Calculate and print the mean of the distance errors less than 100 meters
mean_distance_error_lt_100 = mean(distance_error(distance_error < 100));
fprintf('Mean distance error (less than 100 meters): %.2f meters\n', mean_distance_error_lt_100);
