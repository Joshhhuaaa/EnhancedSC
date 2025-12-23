// ============================================================================
// Project:   Universal Config Tool
// File:      tab_data.cpp
//
// Copyright (c) 2025 Afevis
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// ============================================================================
// ReSharper disable CppClangTidyClangDiagnosticMissingFieldInitializers
#include "pch.h"
#include "tab_data.hpp"

#include "config_keys.hpp"

const std::vector<std::pair<wxString, std::vector<Field>>> kTabs = {
    { wxString("General"), {
        { ConfigKeys::DistanceCulling_Section, ConfigKeys::DistanceCulling_Setting, ConfigKeys::DistanceCulling_IniKey, ConfigKeys::DistanceCulling_Help, ConfigKeys::DistanceCulling_Tooltip,
          std::nullopt, false, Field::Bool, true },

        { ConfigKeys::EnablePauseOnFocusLoss_Section, ConfigKeys::EnablePauseOnFocusLoss_Setting, ConfigKeys::EnablePauseOnFocusLoss_IniKey, ConfigKeys::EnablePauseOnFocusLoss_Help, ConfigKeys::EnablePauseOnFocusLoss_Tooltip,
          std::nullopt, false, Field::Bool, false },

        { ConfigKeys::SkipIntroLogos_Section, ConfigKeys::SkipIntroLogos_Setting, ConfigKeys::SkipIntroLogos_IniKey, ConfigKeys::SkipIntroLogos_Help, ConfigKeys::SkipIntroLogos_Tooltip,
          std::nullopt, false, Field::Bool, false },

        { ConfigKeys::DisableMenuIdleTimers_Section, ConfigKeys::DisableMenuIdleTimers_Setting, ConfigKeys::DisableMenuIdleTimers_IniKey, ConfigKeys::DisableMenuIdleTimers_Help, ConfigKeys::DisableMenuIdleTimers_Tooltip,
          std::nullopt, false, Field::Bool, false },

        { ConfigKeys::EnableRumble_Section, ConfigKeys::EnableRumble_Setting, ConfigKeys::EnableRumble_IniKey, ConfigKeys::EnableRumble_Help, ConfigKeys::EnableRumble_Tooltip,
          std::nullopt, false, Field::Bool, true },
    }},
    { wxString("Warnings"), {
        { ConfigKeys::WarnReadOnlyINIFiles_Section, ConfigKeys::WarnReadOnlyINIFiles_Setting, ConfigKeys::WarnReadOnlyINIFiles_IniKey, ConfigKeys::WarnReadOnlyINIFiles_Help, ConfigKeys::WarnReadOnlyINIFiles_Tooltip,
          std::nullopt, false, Field::Bool, true },

        { ConfigKeys::WarnReadOnlySaveFiles_Section, ConfigKeys::WarnReadOnlySaveFiles_Setting, ConfigKeys::WarnReadOnlySaveFiles_IniKey, ConfigKeys::WarnReadOnlySaveFiles_Help, ConfigKeys::WarnReadOnlySaveFiles_Tooltip,
          std::nullopt, false, Field::Bool, true },
    }},
    { wxString("EnhancedSC / Internal"), {
        { ConfigKeys::CheckForUpdates_Section, ConfigKeys::CheckForUpdates_Setting, ConfigKeys::CheckForUpdates_IniKey, ConfigKeys::CheckForUpdates_Help, ConfigKeys::CheckForUpdates_Tooltip,
          std::nullopt, false, Field::Bool, true },

        { ConfigKeys::VerboseLogging_Section, ConfigKeys::VerboseLogging_Setting, ConfigKeys::VerboseLogging_IniKey, ConfigKeys::VerboseLogging_Help, ConfigKeys::VerboseLogging_Tooltip,
          std::nullopt, false, Field::Bool, false },

        {"About", "", "", "", "", std::nullopt, false, Field::Spacer},

    }}
};
