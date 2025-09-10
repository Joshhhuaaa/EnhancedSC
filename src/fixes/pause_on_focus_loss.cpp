#include "stdafx.h"
#include "pause_on_focus_loss.hpp"

#include <spdlog/spdlog.h>

void PauseOnFocusLoss::Initialize() const
{
    spdlog::info("Pause on Alt-Tab is {}", shouldPause ? "enabled" : "disabled");
    if (shouldPause)
    {
        return; //Vanilla behavior.
    }

}
