#!/bin/zsh

# Get the current key mapping
current_mapping=$(hidutil property --get "UserKeyMapping")

# Define the exact string you expect for comparison
expected_mapping='(
        {
        HIDKeyboardModifierMappingDst = 30064771296;
        HIDKeyboardModifierMappingSrc = 30064771299;
    },
        {
        HIDKeyboardModifierMappingDst = 30064771299;
        HIDKeyboardModifierMappingSrc = 30064771296;
    }
)'

# Check if the entire current mapping matches the expected mapping
if [[ "$current_mapping" == "$expected_mapping" ]]; then
    # If the keys are in the detected state, swap them to Command <-> Control
hidutil property --set '{"UserKeyMapping":[]}'
else
    # If the keys are in their original state or not recognized, revert them back
    hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x7000000E3,"HIDKeyboardModifierMappingDst":0x7000000E0},{"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0x7000000E3}]}'
fi

