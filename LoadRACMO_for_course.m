
t2mNCs = dir('*T2m*.nc');
% tskinNCs = dir('tskin*.nc');
SMBNCs = dir('*smb*.nc');
%% load lat and lon vectors (should be hte same for all decades
id1 = netcdf.open(SMBNCs(1).name);
%rlon dimid =  0
[dimname, rlondimlength] = netcdf.inqDim(id1, 0);
%rlat dimid =  1
[dimname, rlatdimlength] = netcdf.inqDim(id1, 1);
lon = netcdf.getVar(id1, 0, [0 0], [rlondimlength rlatdimlength]);
lat = netcdf.getVar(id1, 1, [0 0], [rlondimlength rlatdimlength]);
%height dimid =  2
[dimname, Heightdimlength] = netcdf.inqDim(id1, 2);

rlon = netcdf.getVar(id1, 3, 0, [rlondimlength ]);
rlat = netcdf.getVar(id1, 4, [0], [ rlatdimlength]);

%% cycle through decades and extract t, T2m, SMB
t_T2m = [];
% t_Tskin = [];
t_SMB = [];

T2m = [];
% TSkin = [];
SMB = [];


for ii = 1:length(t2mNCs)
disp(['Starting iteration ' num2str(ii) ' out of ' num2str(length(t2mNCs))])

id1 = netcdf.open(t2mNCs(ii).name);
% tSkinid1 = netcdf.open(tskinNCs(ii).name);
SMid1 = netcdf.open(SMBNCs(ii).name);
%% find length of dimensions.
%time dimid =  3
[dimname, timedimlength_t2m] = netcdf.inqDim(id1, 3);
% [dimname, timedimlength_TSkin] = netcdf.inqDim(tSkinid1, 3);
[dimname, timedimlength_SM] = netcdf.inqDim(SMid1, 3);

time_1950_T2m = netcdf.getVar(id1, 8,0, timedimlength_t2m );  % units     = 'days since 1950-01-01 00:00:00.0'
% time_1950_Tskin = netcdf.getVar(tSkinid1, 8,0, timedimlength_TSkin );  % units     = 'days since 1950-01-01 00:00:00.0'
time_1950_SM = netcdf.getVar(SMid1, 8,0, timedimlength_SM );  % units     = 'days since 1950-01-01 00:00:00.0'

t_T2m = [t_T2m; datenum('1950-01-01 00:00:00.0') + time_1950_T2m];
% t_Tskin = [t_Tskin; datenum('1950-01-01 00:00:00.0') + time_1950_Tskin];
t_SMB = [t_SMB; datenum('1950-01-01 00:00:00.0') + time_1950_SM];




disp('Starting NC load...')
t2m_temp = netcdf.getVar(id1, 15,[0 0 0 0],[rlondimlength rlatdimlength Heightdimlength timedimlength_t2m]);
% TSkin_temp = netcdf.getVar(tSkinid1, 15,[0 0 0 0],[rlondimlength rlatdimlength Heightdimlength timedimlength_TSkin]);
SMB_temp = netcdf.getVar(SMid1, 15,[0 0 0 0],[rlondimlength rlatdimlength Heightdimlength timedimlength_SM]);
disp('finished NC load.')



disp('Starting cat...')
T2m = cat(4,T2m,t2m_temp);
% TSkin = cat(4,TSkin,TSkin_temp);
SMB = cat(4,SMB,SMB_temp);
disp('...finished cat.')

clear t2m_temp


end

time_temp = t_T2m;
SMB_ireg = SMB;
%% save
% save('RACMO_ANT_27_T2m','t_T2m','T2m','-v7.3')
% save('RACMO_ANT_27_TSKinT2mSnowMelt','t_T2m','T2m','t_Tskin','TSkin','t_SM','SM')
% save('RACMO_ANT_27_T2m_SMB','time','T2m','SMB','-v7.3')

%% sample onto a regular spatial grid

[X,Y]=geog_to_pol_wgs84_71S(lat,lon);
Xv = min(min(X)):27000:max(max(X));
Yv = min(min(Y)):27000:max(max(Y));
%  Xv = linspace(min(min(X)),max(max(X)),280);
%     Yv = linspace(min(min(Y)),max(max(Y)),260);

%% subset, to make it a smaller file

Tstart = datenum(1990,01,01);
Tend = datenum(1999,12,31);
Istart = find(time_temp>Tstart);
Iend = find(time_temp>Tend);

T2m = T2m(:,:,:,Istart:Iend);
SMB = SMB(:,:,:,Istart:Iend);
time = time_temp(Istart:Iend);
%%





[Xvmesh,Yvmesh] = meshgrid(Xv,Yv);
T2m_reg = nan(length(Yv),length(Xv),length(time));
tic
parfor kk = 1:length(time)
    T2m_reg(:,:,kk)=griddata(X,Y,double(T2m(:,:,1,kk)),Xvmesh,Yvmesh);
    kk
end
toc
% imagesc(Yv,Xv,T2m_reg(:,:,1)); set(gca,'YDir','normal'); axis equal


% [Xvmesh,Yvmesh] = meshgrid(Xv,Yv);
SMB_reg = nan(length(Yv),length(Xv),length(time));
tic
parfor kk = 1:length(time)
    SMB_reg(:,:,kk)=griddata(X,Y,double(SMB(:,:,1,kk)),Xvmesh,Yvmesh);
    kk
end
toc
 %% subset in space
Ix = find(Xv>-2.7e6 &  Xv<2.88e6 )
Iy = find(Yv>-2.28e6 &  Yv<2.53e6 )
T = T2m_reg(Iy,Ix,:);
SMB = SMB_reg(Iy,Ix,:);
X = Xv(Ix);
Y = Yv(Iy);

save('RACMO_T_SMB','time','T','SMB','X','Y','-v7.3')


