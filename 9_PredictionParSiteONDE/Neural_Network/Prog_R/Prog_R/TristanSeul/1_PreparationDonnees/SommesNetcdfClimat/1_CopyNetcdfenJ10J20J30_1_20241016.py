import numpy as np
import netCDF4
import shutil
import os

# Chemin de base à explorer
base_dir_origin = "/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/"
base_dir_J10 = "/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/"
base_dir_J20 = "/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/"
base_dir_J30 = "/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/"

# Liste pour stocker les fichiers correspondants
file_historical = []
file_rcp26 = []
file_rcp45 = []
file_rcp85 = []

# Parcourir les répertoires et fichiers dans le chemin de base
for root, dirs, files in os.walk(base_dir_origin):
    for file in files:
        if "historical" in file:        # Vérifier si "historical" et "prtotAdjust" sont dans le nom du fichier
            file_historical.append(os.path.join(root, file))            # Ajouter le chemin complet du fichier correspondant à la liste
        if "rcp26" in file:        # Vérifier si "historical" et "prtotAdjust" sont dans le nom du fichier
            file_rcp26.append(os.path.join(root, file))            # Ajouter le chemin complet du fichier correspondant à la liste
        if "rcp45" in file:        # Vérifier si "historical" et "prtotAdjust" sont dans le nom du fichier
            file_rcp45.append(os.path.join(root, file))            # Ajouter le chemin complet du fichier correspondant à la liste
        if "rcp85" in file:        # Vérifier si "historical" et "prtotAdjust" sont dans le nom du fichier
            file_rcp85.append(os.path.join(root, file))            # Ajouter le chemin complet du fichier correspondant à la liste


for file in file_historical:
    print(file)

    # Obtenir le nom de fichier sans son extension
    filename = os.path.basename(file)  # ex: "file_historical.nc"
    filename_without_extension, extension = os.path.splitext(filename)  # Sépare le nom et l'extension
    
    # Copier vers base_dir_J10 avec suffixe "J10Jj"
    new_filename_J10 = f"{filename_without_extension}_J10Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J10, new_filename_J10))
    
    # Copier vers base_dir_J20 avec suffixe "J20Jj"
    new_filename_J20 = f"{filename_without_extension}_J20Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J20, new_filename_J20))
    
    # Copier vers base_dir_J30 avec suffixe "J30Jj"
    new_filename_J30 = f"{filename_without_extension}_J30Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J30, new_filename_J30))
    
    print("Fichiers copiés et renommés avec succès.")


for file in file_rcp26:
    print(file)

    # Obtenir le nom de fichier sans son extension
    filename = os.path.basename(file)  # ex: "file_historical.nc"
    filename_without_extension, extension = os.path.splitext(filename)  # Sépare le nom et l'extension
    
    # Copier vers base_dir_J10 avec suffixe "J10Jj"
    new_filename_J10 = f"{filename_without_extension}_J10Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J10, new_filename_J10))
    
    # Copier vers base_dir_J20 avec suffixe "J20Jj"
    new_filename_J20 = f"{filename_without_extension}_J20Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J20, new_filename_J20))
    
    # Copier vers base_dir_J30 avec suffixe "J30Jj"
    new_filename_J30 = f"{filename_without_extension}_J30Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J30, new_filename_J30))
    
    print("Fichiers copiés et renommés avec succès.")


for file in file_rcp45:
    print(file)

    # Obtenir le nom de fichier sans son extension
    filename = os.path.basename(file)  # ex: "file_historical.nc"
    filename_without_extension, extension = os.path.splitext(filename)  # Sépare le nom et l'extension
    
    # Copier vers base_dir_J10 avec suffixe "J10Jj"
    new_filename_J10 = f"{filename_without_extension}_J10Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J10, new_filename_J10))
    
    # Copier vers base_dir_J20 avec suffixe "J20Jj"
    new_filename_J20 = f"{filename_without_extension}_J20Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J20, new_filename_J20))
    
    # Copier vers base_dir_J30 avec suffixe "J30Jj"
    new_filename_J30 = f"{filename_without_extension}_J30Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J30, new_filename_J30))
    
    print("Fichiers copiés et renommés avec succès.")


for file in file_rcp85:
    print(file)

    # Obtenir le nom de fichier sans son extension
    filename = os.path.basename(file)  # ex: "file_historical.nc"
    filename_without_extension, extension = os.path.splitext(filename)  # Sépare le nom et l'extension
    
    # Copier vers base_dir_J10 avec suffixe "J10Jj"
    new_filename_J10 = f"{filename_without_extension}_J10Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J10, new_filename_J10))
    
    # Copier vers base_dir_J20 avec suffixe "J20Jj"
    new_filename_J20 = f"{filename_without_extension}_J20Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J20, new_filename_J20))
    
    # Copier vers base_dir_J30 avec suffixe "J30Jj"
    new_filename_J30 = f"{filename_without_extension}_J30Jj{extension}"
    shutil.copy(file, os.path.join(base_dir_J30, new_filename_J30))
    
    print("Fichiers copiés et renommés avec succès.")


