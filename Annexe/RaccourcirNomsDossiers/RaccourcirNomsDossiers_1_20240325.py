import os
import re

def read_patterns_from_file(file_path):
    patterns = []
    with open(file_path, 'r') as file:
        for line in file:
            pattern_to_replace, replacement = line.strip().split(';')
            patterns.append((pattern_to_replace, replacement))
    return patterns

def rename_recursive(root_dir, patterns):
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            old_file_path = os.path.join(root, file)
            new_file_name = file
            for pattern_to_replace, replacement in patterns:
                new_file_name = re.sub(pattern_to_replace, replacement, new_file_name)
            new_file_path = os.path.join(root, new_file_name)
            os.rename(old_file_path, new_file_path)
            print(f"Renamed {old_file_path} to {new_file_path}")

        for dir in dirs:
            old_dir_path = os.path.join(root, dir)
            new_dir_name = dir
            for pattern_to_replace, replacement in patterns:
                new_dir_name = re.sub(pattern_to_replace, replacement, new_dir_name)
            new_dir_path = os.path.join(root, new_dir_name)
            os.rename(old_dir_path, new_dir_path)
            print(f"Renamed {old_dir_path} to {new_dir_path}")

if __name__ == "__main__":
    root_directory = "/media/tjaouen/My Passport/DonneesTristanJ_Assecs/"
    patterns_file = "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/RaccourcirNomsDossiers/PatternsRemplacement.txt"

    if not os.path.exists(patterns_file):
        print("Error: Patterns file not found.")
    else:
        patterns = read_patterns_from_file(patterns_file)
        print(patterns)
        rename_recursive(root_directory, patterns)
        print("\nRenaming completed successfully.")
