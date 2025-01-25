#!/bin/bash

# Установка Zsh и необходимых утилит
echo "Установка Zsh и зависимостей..."
sudo apt update
sudo apt install -y zsh git curl wget neovim fzf exa bat

# Установка Oh My Zsh
echo "Проверка Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Установка Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh уже установлен."
fi

# Загрузка и применение .zshrc
echo "Загрузка и применение .zshrc..."
ZSH_RC_URL="https://raw.githubusercontent.com/etern01/dots/refs/heads/master/.zshrc"
curl -fsSL "$ZSH_RC_URL" -o "$HOME/.zshrc"

# Установка плагинов
echo "Установка плагинов..."
PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$PLUGINS_DIR"

plugins=(
    "https://github.com/tom-auger/cmdtime.git"
    "https://github.com/hlissner/zsh-autopair.git"
    "https://github.com/zsh-users/zsh-completions.git"
    "https://github.com/zsh-users/zsh-autosuggestions.git"
    "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
)

for plugin in "${plugins[@]}"; do
    plugin_name=$(basename "$plugin" .git)
    if [ ! -d "$PLUGINS_DIR/$plugin_name" ]; then
        echo "Установка плагина: $plugin_name"
        git clone "$plugin" "$PLUGINS_DIR/$plugin_name"
    else
        echo "Плагин $plugin_name уже установлен."
    fi
done

# Установка Powerlevel10k (если используется)
if grep -q "powerlevel10k" "$HOME/.zshrc"; then
    echo "Установка Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
fi

# Смена оболочки на Zsh
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "Смена оболочки на Zш..."
    chsh -s /bin/zsh
fi

echo "Настройка завершена. Перезагрузите терминал или выполните 'zsh' для применения изменений."
