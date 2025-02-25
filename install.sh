#!/sbin/sh

SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true
REPLACE="
"

# Функция для вывода названия модуля
print_modname() {
    unzip -o "${ZIPFILE}" module.prop -d "${TMPDIR}" >&2
    local MOD_PROP="$(cat "${TMPDIR}/module.prop")"

    local MOD_NAME="$(echo "${MOD_PROP}" | grep "name=")"
    MOD_NAME=${MOD_NAME:5}

    local MOD_VERSION="$(echo "${MOD_PROP}" | grep "version=")"
    MOD_VERSION=${MOD_VERSION:8}

    ui_print "***********************************"
    ui_print "  MODULE NAME: ${MOD_NAME}"
    ui_print "  VERSION: ${MOD_VERSION}"
    ui_print "***********************************"
}

# Функция для установки
on_install() {
    local BOOT_DIR=""
    local BOOT_DIR2=""
    
    ui_print "[] Searching for bootanimation.zip..."
    
    # Проверяем наличие bootanimation.zip в стандартных папках
    if [ -f "/system/media/bootanimation.zip" ]; then
        BOOT_DIR2="/system/media"
        BOOT_DIR="${MODPATH}/system/media"
    elif [ -f "/system/product/media/bootanimation.zip" ]; then
        BOOT_DIR2="/system/product/media"
        BOOT_DIR="${MODPATH}/system/product/media"
    elif [ -f "/vendor/media/bootanimation.zip" ]; then
        BOOT_DIR="/vendor/media"
        BOOT_DIR="${MODPATH}/vendor/media"
    elif [ -f "/system/vendor/media/bootanimation.zip" ]; then
        BOOT_DIR2="/system/vendor/media"
        BOOT_DIR="${MODPATH}/system/vendor/media"
    else
        ui_print "  -Error: bootanimation.zip not found in any standard directory!"
        return 1
    fi

    ui_print "  +Found bootanimation.zip in: "
    ui_print "   ${BOOT_DIR2}"
    
    # Извлекаем анимацию
    ui_print "[] Extracting boot animation to: "
    ui_print "    ${BOOT_DIR}"
    mkdir -p "${BOOT_DIR}" >&2
    unzip -o "${ZIPFILE}" bootanimation.zip -d "${BOOT_DIR}" >&2
    
    ui_print "  +Extraction completed."
}

# Функция для установки прав
set_permissions() {
    ui_print "[] Setting chmod 755..."
    set_perm_recursive "${MODPATH}" 0 0 0755 0644 || return 1
    ui_print "  +chmod set."
}

# Функция для сообщения об успешном выполнении
success() {
ui_print ""
ui_print "✓ Boot animation has been set successfully! "
}

