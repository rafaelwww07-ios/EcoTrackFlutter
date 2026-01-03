import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';

export '../../../../core/theme/app_theme.dart' show AppColorPalette, AppThemeMode;

/// Theme selector widget
class ThemeSelector extends StatefulWidget {
  final VoidCallback? onThemeChanged;
  
  const ThemeSelector({super.key, this.onThemeChanged});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  AppColorPalette _selectedPalette = AppColorPalette.eco;
  AppThemeMode _selectedMode = AppThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final paletteIndex = prefs.getInt(AppConstants.keyColorPalette) ?? 0;
    final modeIndex = prefs.getInt(AppConstants.keyThemeMode) ?? 2;
    
    setState(() {
      _selectedPalette = AppColorPalette.values[paletteIndex];
      _selectedMode = AppThemeMode.values[modeIndex];
    });
  }

  Future<void> _saveThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      AppConstants.keyColorPalette,
      _selectedPalette.index,
    );
    await prefs.setInt(
      AppConstants.keyThemeMode,
      _selectedMode.index,
    );
    // Notify parent widget to reload theme
    widget.onThemeChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.colorPalette,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: AppColorPalette.values.map((palette) {
                final isSelected = _selectedPalette == palette;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPalette = palette;
                        });
                        _saveThemeSettings();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? context.colors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _getPaletteColor(palette),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getPaletteName(palette, l10n),
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.themeMode,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SegmentedButton<AppThemeMode>(
              segments: [
                ButtonSegment(
                  value: AppThemeMode.light,
                  label: Text(l10n.light),
                  icon: const Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: AppThemeMode.dark,
                  label: Text(l10n.dark),
                  icon: const Icon(Icons.dark_mode),
                ),
                ButtonSegment(
                  value: AppThemeMode.system,
                  label: Text(l10n.auto),
                  icon: const Icon(Icons.brightness_auto),
                ),
              ],
              selected: {_selectedMode},
              onSelectionChanged: (Set<AppThemeMode> newSelection) {
                setState(() {
                  _selectedMode = newSelection.first;
                });
                _saveThemeSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getPaletteColor(AppColorPalette palette) {
    switch (palette) {
      case AppColorPalette.eco:
        return AppTheme.ecoPrimary;
      case AppColorPalette.minimalist:
        return AppTheme.minPrimary;
      case AppColorPalette.vibrant:
        return AppTheme.vibPrimary;
    }
  }

  String _getPaletteName(AppColorPalette palette, AppLocalizations l10n) {
    switch (palette) {
      case AppColorPalette.eco:
        return l10n.eco;
      case AppColorPalette.minimalist:
        return l10n.minimalist;
      case AppColorPalette.vibrant:
        return l10n.vibrant;
    }
  }
}

