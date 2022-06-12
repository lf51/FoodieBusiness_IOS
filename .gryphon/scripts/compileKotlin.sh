# Exit if any command fails
set -e

# Prints a file only if it exists (and waits a bit so the printing can finish before proceeding)
safeCat () {
	if [[ -f $1 ]];
	then
		cat $1
		sleep 2
	fi
}

# Remove old logs
# The `-f` option is here to avoid reporting errors when the files are not found
rm -f "$SRCROOT/.gryphon/gradleOutput.txt"
rm -f "$SRCROOT/.gryphon/gradleErrors.txt"
rm -f "$SRCROOT/.gryphon/swiftOutput.txt"
rm -f "$SRCROOT/.gryphon/swiftErrors.txt"

# TODO: remove this after a migration period
if [ -z ${ANDROID_ROOT+x} ]
then
	echo ""
else
	1>&2 echo "The ANDROID_ROOT folder should now be set using a config file."
	1>&2 echo "Please delete the ANDROID_ROOT variable from your Xcode build settings."
	1>&2 echo "If you need to, run "gryphon init \<xcodeproj\>" again to create"
	1>&2 echo "a new config file where you can set your ANDROID_ROOT."
	1>&2 echo "For more information, read the tutorial at"
	1>&2 echo "https://vinivendra.github.io/Gryphon/buildingTheAndroidAppUsingXcode.html"
	exit -1
fi

# Analyze the config files
regex="ANDROID_ROOT[ ]*=[ ]*(.+)"
androidRootPath="null"
for file in $CONFIG_FILES
do
	# Read each line of the file in the path
	while read line
	do
		if [[ $line =~ $regex ]]
		then
			androidRootPath="${BASH_REMATCH[1]}"
		fi
	done < $file
done

if [ "$androidRootPath" == "null" ]
then
	1>&2 echo "Error: no ANDROID_ROOT configuration found in the given config files:"
	1>&2 echo "$CONFIG_FILES"
	1>&2 echo "Try adjusting the contents of your config files"
	1>&2 echo "or adjusting the CONFIG_FILES build setting in Xcode."
	exit -1
fi

# Switch to the Android folder so we can use pre-built gradle info to speed up the compilation.
cd "$androidRootPath"

# Compile the Android sources and save the logs gack to the iOS folder
set +e
./gradlew compileDebugSources > \
	"$SRCROOT/.gryphon/gradleOutput.txt" 2> \
	"$SRCROOT/.gryphon/gradleErrors.txt"
kotlinCompilationStatus=$?
set -e

# Switch back to the iOS folder
cd "$SRCROOT"

set +e

# Map the Kotlin errors back to Swift
swift .gryphon/scripts/mapGradleErrorsToSwift.swift \
	< .gryphon/gradleOutput.txt \
	> .gryphon/swiftOutput.txt

swift .gryphon/scripts/mapGradleErrorsToSwift.swift \
	< .gryphon/gradleErrors.txt \
	> .gryphon/swiftErrors.txt

# Print the errors
if [ -s .gryphon/swiftOutput.txt ] || \
	[ -s .gryphon/swiftErrors.txt ]
then
	# If there are errors in Swift files (the Swift output and error files aren't empty)
	safeCat .gryphon/swiftOutput.txt
	safeCat .gryphon/swiftErrors.txt
	exit -1
else
	# If the Swift files are empty, print the Kotlin output (there may have been other errors)
	# and exit with the Kotlin compiler's status
	safeCat .gryphon/gradleOutput.txt
	safeCat .gryphon/gradleErrors.txt
	exit $kotlinCompilationStatus
fi
