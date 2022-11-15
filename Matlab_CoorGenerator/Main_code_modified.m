% Generate Synthetic 3D Structure with Ellipses
% Mark Tschopp
% 2016
% Random Sequential Adsorption algorithm that varies ellipse volume fraction, size, aspect ratio, and orientation

clear all; 
clc;
% Initialize variables used in generation of 3D microstructure
tic;
Vf = 0; Vf_max = 0.25; 
a = 24; b = 8; c = 8; % aspect ratio =3
nparticles = 0;
I = false(250,250,250); 
image_size = size(I);
rp = a;
x_max =  250; x_min =  0;
y_max =  250; y_min =  0;
z_max =  250; z_min =  0;

% Calculate approximate Vf of particle and approximate number of
% particles to generate the specified volume fraction. This
% will impact the time that it takes to render the 3D volume.

% Assign random orientation
alpha = 2*pi*rand; beta = pi*rand; gamma = 2*pi*rand;
I_ellipse = image_ellipse_3D_fast(a,b,c,alpha,beta,gamma);

Vf_particle = sum(I_ellipse(:)) / numel(I);
approx_nparticles = Vf_max/Vf_particle;
disp(['Approximate # of particles: ' num2str(approx_nparticles)]);

% Main loop for generating microstructure
h = waitbar(0,'Ellipsoid placement');
while Vf < Vf_max
    alpha = 2*pi*rand; 
    beta = pi*rand;
    gamma = 2*pi*rand;

    I_ellipse = image_ellipse_3D_fast(a,b,c,alpha,beta,gamma);
    
    x0 = ceil(((x_max-rp)-(x_min+rp))*rand+x_min+rp);
    y0 = ceil(((y_max-rp)-(y_min+rp))*rand+y_min+rp);
    z0 = ceil(((z_max-rp)-(z_min+rp))*rand+z_min+rp);
    diam = size(I_ellipse,1);

    % Merge circle matrix with synthetic microstructure image
    nlo = x0 - floor(diam/2); nhi = x0 + ceil(diam/2)-1;
    ix = mod(nlo:nhi,image_size(1));ix(ix==0)=image_size(1);
    nlo = y0 - floor(diam/2); nhi = y0 + ceil(diam/2)-1;
    iy = mod(nlo:nhi,image_size(2));iy(iy==0)=image_size(2);
    nlo = z0 - floor(diam/2); nhi = z0 + ceil(diam/2)-1;
    iz = mod(nlo:nhi,image_size(3));iz(iz==0)=image_size(3);

    Itest = logical(I(ix,iy,iz));
    if sum(Itest(I_ellipse)) == 0
        Itest(I_ellipse) = 1;
        I(ix,iy,iz) = Itest;
        accept = 1;
    else
        accept = 0;
        iter = 0;
    
        while accept == 0 && iter <= 10
            iter = iter + 1;
            x0 = ceil(((x_max-rp)-(x_min+rp))*rand+x_min+rp);
            y0 = ceil(((y_max-rp)-(y_min+rp))*rand+y_min+rp);
            z0 = ceil(((z_max-rp)-(z_min+rp))*rand+z_min+rp);
            diam = size(I_ellipse,1);
            % Merge circle matrix with synthetic microstructure
            nlo = x0 - floor(diam/2); nhi = x0 + ceil(diam/2)-1;
            ix = mod(nlo:nhi,image_size(1));
            ix(ix==0)=image_size(1);
            nlo = y0 - floor(diam/2); nhi = y0 + ceil(diam/2)-1;
            iy = mod(nlo:nhi,image_size(2));
            iy(iy==0)=image_size(2);
            nlo = z0 - floor(diam/2); nhi = z0 + ceil(diam/2)-1;
            iz = mod(nlo:nhi,image_size(3));
            iz(iz==0)=image_size(3);
            Itest = logical(I(ix,iy,iz));
            if sum(Itest(I_ellipse)) == 0
                Itest(I_ellipse) = 1;
                I(ix,iy,iz) = Itest;
                accept = 1;
            end
        end
    end


    if accept;
        nparticles = nparticles + 1;
        Vf_particle = sum(I_ellipse(:)) / numel(I);
        Vf = Vf + Vf_particle;
        ellipse(nparticles,1:10) = ...
        [x0 y0 z0 a b c alpha beta gamma Vf_particle];
    end
    
    waitbar(Vf/Vf_max)

end

close(h)
disp(['3D Digital Slices (sec): ' num2str(toc)]);
disp(['Number of particles: ' num2str(nparticles)]);

% Write ellipse parameters to Excel
% Store all ellipse parameters in Excel so that the 3D structure
% can be generated without worrying about overlap.

image_save_flag = 1;

if image_save_flag
    string_path = pwd;
    Excel_fileName = sprintf('%s\\3D_ellipses.xlsx',string_path);
    sheet = sprintf('ellipse_%dvf_%da_%db_%dc_%05d',...
    round(100*Vf),a,b,c,nparticles);
    warning off MATLAB:xlswrite:AddSheet;
    ColHeaders = {'x0','y0','z0','a','b','c','alpha','beta','gamma'};
    xlswrite(Excel_fileName, ColHeaders, sheet, 'A1');
    xlswrite(Excel_fileName, ellipse, sheet, 'A2');
    deleteEmptyExcelSheets(Excel_fileName);
end

% View slices of a 3D section
% This routine views 2D orthogonal planes in the 3D structure as a
% function of depth

j=1;
close all;
figure;
while j
    for i = 1:image_size(3)
        J = 1-I(:,:,i);

        image_view(J);
        title(['Slice ' num2str(i)])
        pause(0.05)
    end
end
% Hit control-C to exit

% Save individual slices as jpegs for animated gifs
% For use with ImageJ - First, open ImageJ and select Plugins -> List
% Opener, then select the *.txt file that contains all the image
% paths. Once the images are loaded in ImageJ, then convert them to
% Slices using the Image -> Stacks -> Image to Stacks command. Now
% the stack of images can be saved as an animated *.gif format for
% insertion into Powerpoint. The Volume viewer and VolumeJ renderers
% in ImageJ also accept stacks of images.

tic
close all; figure;
sheetname = sprintf('ellipse_%dvf_%da_%db_%dc_%05d',...
    round(100*Vf),a,b,c,nparticles);
if ~isdir(sheetname), mkdir(sheetname); end
copyfile('image_view.m',sheetname)
cd(sheetname)
fid = fopen([sheetname '.txt'],'w');
for i = 1:image_size(3)
    K = reshape(1-I(:,:,i),image_size(1),image_size(2));
    J = K;
    image_view(J);
    pause(0.05)
    image_filename = [sheetname, sprintf('_%03d.jpg',i)];
    fprintf(fid,'%s \n',image_filename);
    if image_save_flag; imwrite(J,image_filename,'jpg'); end
end
fclose(fid);
delete('image_view.m')
cd ..
% Save to *.mat file as well
save([sheetname '.mat'],'I')
disp(['Image viewing and saving (sec): ' num2str(toc)]);

% *.mat file is useful for subsequent operations in MATLAB or writing
% files, *.jpg is useful for visualization, *.tif binaries are a useful
% if lossless compression is desired, *.txt contains a list of images,
% *.xls contains spreadsheet with all ellipse parameters, if desired