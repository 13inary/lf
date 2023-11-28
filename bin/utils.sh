#!/bin/bash

function split_string_to_array {
	local input="$1"
	local result=()

	mapfile -t result <<<"$input"
	echo "${result[@]}"
}

function join_array_to_string {
	local input=("$@")
	local result=""
	local delimiter=$'\n'

	for element in "${input[@]}"; do
		if [ -n "$result" ]; then
			result="${result}${delimiter}"
		fi

		result="${result}${element}"
	done

	echo "${result}"
}

function delete_string_item() {
	local srcString="$1"
	local lines=($(split_string_to_array "${srcString}"))
	local prefix="$2"
	local new=()

	for element in "${lines[@]}"; do
		if [[ $element == $prefix* ]]; then
			continue
		fi
		new+=("$element")
	done

	echo "$(join_array_to_string "${new[@]}")"
}

function add_string_item() {
	local srcString="$1"
	local newItem="$2"

	lines=($(split_string_to_array "${srcString}"))

	newLines=("${newItem}" "${lines[@]}")

	echo "$(join_array_to_string "${newLines[@]}")"
}
