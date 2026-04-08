#!/bin/bash
# ═══════════════════════════════════════════════
# SplitEasy — Script de compilation automatique
# ═══════════════════════════════════════════════
set -e

echo "╔══════════════════════════════════╗"
echo "║   SplitEasy — Build Android APK  ║"
echo "╚══════════════════════════════════╝"

# ── 1. Vérifier Java ──
if ! command -v java &>/dev/null; then
  echo "❌ Java non trouvé. Installez JDK 17+:"
  echo "   Ubuntu/Debian: sudo apt install openjdk-17-jdk"
  echo "   Mac: brew install openjdk@17"
  exit 1
fi
echo "✅ Java: $(java -version 2>&1 | head -1)"

# ── 2. Vérifier Android SDK ──
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
  # Essayer les chemins courants
  for path in "$HOME/Android/Sdk" "$HOME/Library/Android/sdk" "/opt/android-sdk"; do
    if [ -d "$path" ]; then
      export ANDROID_HOME="$path"
      export ANDROID_SDK_ROOT="$path"
      break
    fi
  done
fi

if [ -z "$ANDROID_HOME" ]; then
  echo ""
  echo "❌ Android SDK non trouvé."
  echo "   Téléchargez Android Studio: https://developer.android.com/studio"
  echo "   Puis relancez ce script."
  echo ""
  echo "   Ou installez le SDK seul:"
  echo "   https://developer.android.com/studio#command-tools"
  exit 1
fi
echo "✅ Android SDK: $ANDROID_HOME"

# ── 3. Rendre gradlew exécutable ──
chmod +x gradlew

# ── 4. Compiler le debug APK ──
echo ""
echo "🔨 Compilation en cours (première fois: ~5 min)..."
./gradlew assembleDebug --no-daemon 2>&1

# ── 5. Résultat ──
APK="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK" ]; then
  SIZE=$(du -h "$APK" | cut -f1)
  echo ""
  echo "╔══════════════════════════════════╗"
  echo "║  ✅ APK généré avec succès !     ║"
  echo "╚══════════════════════════════════╝"
  echo "📦 Fichier: $APK"
  echo "📏 Taille:  $SIZE"
  echo ""
  echo "📲 Pour installer sur Android:"
  echo "   Méthode 1 (câble USB):"
  echo "   adb install $APK"
  echo ""
  echo "   Méthode 2 (direct):"
  echo "   Copiez le fichier APK sur votre téléphone"
  echo "   Activez 'Sources inconnues' dans Paramètres"
  echo "   Appuyez sur le fichier APK pour installer"
else
  echo "❌ Échec de la compilation. Vérifiez les logs ci-dessus."
  exit 1
fi
