import numpy as np
import netCDF4
import os

# Ouverture des fichiers NetCDF
# nc_evspsblpotAdjust_historical_ = netCDF4.Dataset("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_Hg0175_J30Jj.nc", "r+")
# nc_evspsblpotAdjust_rcp26_ = netCDF4.Dataset("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J30Jj.nc", "r+")
# nc_evspsblpotAdjust_rcp45_ = netCDF4.Dataset("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J30Jj.nc", "r+")
# nc_evspsblpotAdjust_rcp85_ = netCDF4.Dataset("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J30Jj.nc", "r+")

# Chemin de base à explorer
base_dir = "/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/"

# Liste pour stocker les fichiers correspondants
file_historical = []
file_rcp26 = []
file_rcp45 = []
file_rcp85 = []

# Parcourir les répertoires et fichiers dans le chemin de base
for root, dirs, files in os.walk(base_dir):
    for file in files:
        if "historical" in file and "evspsblpotAdjust" in file:        # Vérifier si "historical" et "prtotAdjust" sont dans le nom du fichier
            file_historical.append(os.path.join(root, file))            # Ajouter le chemin complet du fichier correspondant à la liste
        if "rcp26" in file and "evspsblpotAdjust" in file:        # Vérifier si "historical" et "prtotAdjust" sont dans le nom du fichier
            file_rcp26.append(os.path.join(root, file))            # Ajouter le chemin complet du fichier correspondant à la liste
        if "rcp45" in file and "evspsblpotAdjust" in file:        # Vérifier si "historical" et "prtotAdjust" sont dans le nom du fichier
            file_rcp45.append(os.path.join(root, file))            # Ajouter le chemin complet du fichier correspondant à la liste
        if "rcp85" in file and "evspsblpotAdjust" in file:        # Vérifier si "historical" et "prtotAdjust" sont dans le nom du fichier
            file_rcp85.append(os.path.join(root, file))            # Ajouter le chemin complet du fichier correspondant à la liste

for file in file_historical:
    print(file)
for file in file_rcp26:
    print(file)
for file in file_rcp45:
    print(file)
for file in file_rcp85:
    print(file)

nc_evspsblpotAdjust_historical_ = netCDF4.Dataset(file_historical[0], "r+")
nc_evspsblpotAdjust_rcp26_ = netCDF4.Dataset(file_rcp26[0], "r+")
nc_evspsblpotAdjust_rcp45_ = netCDF4.Dataset(file_rcp45[0], "r+")
nc_evspsblpotAdjust_rcp85_ = netCDF4.Dataset(file_rcp85[0], "r+")

# Lecture des variables evspsblpotAdjust
evspsblpotAdjust_historical_ = nc_evspsblpotAdjust_historical_.variables['evspsblpotAdjust'][:]
print(evspsblpotAdjust_historical_.shape)

evspsblpotAdjust_rcp26_ = nc_evspsblpotAdjust_rcp26_.variables['evspsblpotAdjust'][:]
print(evspsblpotAdjust_rcp26_.shape)
evspsblpotAdjust_rcp45_ = nc_evspsblpotAdjust_rcp45_.variables['evspsblpotAdjust'][:]
print(evspsblpotAdjust_rcp45_.shape)
evspsblpotAdjust_rcp85_ = nc_evspsblpotAdjust_rcp85_.variables['evspsblpotAdjust'][:]
print(evspsblpotAdjust_rcp85_.shape)

# Concaténation des matrices selon la 3ème dimension
evspsblpotAdjust_combined_26_ = np.concatenate((evspsblpotAdjust_historical_, evspsblpotAdjust_rcp26_), axis=0)
print(evspsblpotAdjust_combined_26_.shape)
evspsblpotAdjust_combined_45_ = np.concatenate((evspsblpotAdjust_historical_, evspsblpotAdjust_rcp45_), axis=0)
print(evspsblpotAdjust_combined_45_.shape)
evspsblpotAdjust_combined_85_ = np.concatenate((evspsblpotAdjust_historical_, evspsblpotAdjust_rcp85_), axis=0)
print(evspsblpotAdjust_combined_85_.shape)

# Initialisation de la variable de sortie avec les mêmes dimensions
evspsblpotAdjust_JjJ30_26_ = np.copy(evspsblpotAdjust_combined_26_)
n_slices_26_ = evspsblpotAdjust_JjJ30_26_.shape[0]
print("n_slices_26_=",n_slices_26_)
evspsblpotAdjust_JjJ30_45_ = np.copy(evspsblpotAdjust_combined_45_)
n_slices_45_ = evspsblpotAdjust_JjJ30_45_.shape[0]
print("n_slices_45_",n_slices_45_)
evspsblpotAdjust_JjJ30_85_ = np.copy(evspsblpotAdjust_combined_85_)
n_slices_85_ = evspsblpotAdjust_JjJ30_85_.shape[0]
print("n_slices_85_",n_slices_85_)

# Remplir les 30 premières slices avec des NaN
for i in range(30, n_slices_26_):
    if i % 2500 == 0:
        print(f"Slice i: {i}")
    evspsblpotAdjust_JjJ30_26_[i,:,:] = np.sum(evspsblpotAdjust_combined_26_[(i-30):(i+1),:,:], axis=0)
evspsblpotAdjust_JjJ30_26_[:30, :, :] = np.nan

for i in range(30, n_slices_45_):
    if i % 2500 == 0:
        print(f"Slice i: {i}")
    evspsblpotAdjust_JjJ30_45_[i,:,:] = np.sum(evspsblpotAdjust_combined_45_[(i-30):(i+1),:,:], axis=0)
evspsblpotAdjust_JjJ30_45_[:30, :, :] = np.nan

for i in range(30, n_slices_85_):
    if i % 2500 == 0:
        print(f"Slice i: {i}")
    evspsblpotAdjust_JjJ30_85_[i,:,:] = np.sum(evspsblpotAdjust_combined_85_[(i-30):(i+1),:,:], axis=0)
evspsblpotAdjust_JjJ30_85_[:30, :, :] = np.nan


# Séparation des données historiques et rcp26
evspsblpotAdjust_historical_ = evspsblpotAdjust_JjJ30_26_[:evspsblpotAdjust_historical_.shape[0], :, :]
evspsblpotAdjust_rcp26_ = evspsblpotAdjust_JjJ30_26_[evspsblpotAdjust_historical_.shape[0]:, :, :]
evspsblpotAdjust_rcp45_ = evspsblpotAdjust_JjJ30_45_[evspsblpotAdjust_historical_.shape[0]:, :, :]
evspsblpotAdjust_rcp85_ = evspsblpotAdjust_JjJ30_85_[evspsblpotAdjust_historical_.shape[0]:, :, :]

# Ecriture des variables mises à jour dans les fichiers NetCDF
nc_evspsblpotAdjust_historical_.variables['evspsblpotAdjust'][:] = evspsblpotAdjust_historical_
nc_evspsblpotAdjust_rcp26_.variables['evspsblpotAdjust'][:] = evspsblpotAdjust_rcp26_
nc_evspsblpotAdjust_rcp45_.variables['evspsblpotAdjust'][:] = evspsblpotAdjust_rcp45_
nc_evspsblpotAdjust_rcp85_.variables['evspsblpotAdjust'][:] = evspsblpotAdjust_rcp85_

# Fermer les fichiers NetCDF
nc_evspsblpotAdjust_historical_.close()
nc_evspsblpotAdjust_rcp26_.close()
nc_evspsblpotAdjust_rcp45_.close()
nc_evspsblpotAdjust_rcp85_.close()





# nc_evspsblpotAdjust_historical_ = Dataset("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_Hg0175.nc", "r")
# nc_tasAdjust_historical_ = Dataset("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/tasAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231.nc", "r")
# nc_evspsblpotAdjust_rcp26_ = Dataset("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175.nc", "r")
# nc_tasAdjust_rcp26_ = Dataset("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231.nc", "r")

