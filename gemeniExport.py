import os

# Fichier de sortie
OUTPUT_FILE = "PROJECT_CONTEXT.md"

# Extensions à inclure dans le résumé
VALID_EXTENSIONS = {'.gd', '.tscn', '.gdshader'}

# Dossiers à ignorer royalement
IGNORE_DIRS = {'.godot', '.git', 'import', '.import'}

def generate_context():
    project_root = os.getcwd()
    
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as out:
        out.write("# 🎮 Contexte du Projet Godot - Art Of Ida\n\n")
        
        # 1. Génération de l'arborescence du projet
        out.write("## 📁 Arborescence des Fichiers\n```text\n")
        for root, dirs, files in os.walk(project_root):
            # Filtrer les dossiers ignorés
            dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]
            
            level = root.replace(project_root, '').count(os.sep)
            indent = '  ' * level
            out.write(f"{indent}{os.path.basename(root)}/\n")
            subindent = '  ' * (level + 1)
            for f in files:
                ext = os.path.splitext(f)[1]
                if ext in VALID_EXTENSIONS or f == "project.godot":
                    out.write(f"{subindent}{f}\n")
        out.write("```\n\n")
        
        # 2. Extraction du contenu des scripts et scènes
        out.write("## 📜 Contenu des Fichiers Clés\n\n")
        for root, dirs, files in os.walk(project_root):
            dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]
            
            for file in files:
                ext = os.path.splitext(file)[1]
                if ext in VALID_EXTENSIONS:
                    file_path = os.path.join(root, file)
                    rel_path = os.path.relpath(file_path, project_root)
                    
                    out.write(f"### 📄 `{rel_path}`\n\n")
                    
                    # Choix de la balise de code pour la coloration
                    lang = "gdscript" if ext == '.gd' else "glsl" if ext == '.gdshader' else "ini"
                    out.write(f"```{lang}\n")
                    
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            out.write(f.read())
                    except Exception as e:
                        out.write(f"// Erreur lors de la lecture du fichier : {e}")
                        
                    out.write("\n```\n\n")

    print(f"✅ Et voilà le travail ! Ton fichier est prêt : {OUTPUT_FILE}")

if __name__ == "__main__":
    generate_context()