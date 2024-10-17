import subprocess

# Liste des scripts Python à exécuter
scripts = [
    "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/1_PreparationDonnees/SommesNetcdfClimat/2_ConvertNetcdfClimatEnSommes_J10Jj_evspsblpotAdjust_1_20241016.py",
    "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/1_PreparationDonnees/SommesNetcdfClimat/2_ConvertNetcdfClimatEnSommes_J10Jj_prtotAdjust_1_20241011.py",
    # "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/1_PreparationDonnees/SommesNetcdfClimat/2_ConvertNetcdfClimatEnSommes_J10Jj_tasAdjust_1_20241016.py",
    "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/1_PreparationDonnees/SommesNetcdfClimat/2_ConvertNetcdfClimatEnSommes_J20Jj_evspsblpotAdjust_1_20241016.py",
    "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/1_PreparationDonnees/SommesNetcdfClimat/2_ConvertNetcdfClimatEnSommes_J20Jj_prtotAdjust_1_20241011.py",
    "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/1_PreparationDonnees/SommesNetcdfClimat/2_ConvertNetcdfClimatEnSommes_J20Jj_tasAdjust_1_20241016.py",
    "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/1_PreparationDonnees/SommesNetcdfClimat/2_ConvertNetcdfClimatEnSommes_J30Jj_evspsblpotAdjust_1_20241016.py",
    "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/1_PreparationDonnees/SommesNetcdfClimat/2_ConvertNetcdfClimatEnSommes_J30Jj_prtotAdjust_1_20241011.py",
    "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/1_PreparationDonnees/SommesNetcdfClimat/2_ConvertNetcdfClimatEnSommes_J30Jj_tasAdjust_1_20241016.py"]

# Fonction pour exécuter chaque script Python
for script in scripts:
    try:
        # Exécuter le script Python avec subprocess
        print(f"Exécution de {script}...")
        subprocess.run(["python3", script], check=True)
        print(f"{script} a été exécuté avec succès.")
    except subprocess.CalledProcessError as e:
        print(f"Erreur lors de l'exécution de {script}: {e}")
