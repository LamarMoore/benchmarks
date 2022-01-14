# Mark build as passed or failed. The additional "|| true" stops the build from failing if there are no errors.
cppcheck_file = "./build/cppcheck.xml"
errors_count=$(grep -c '</error>' $cppcheck_file) || true
if [ $errors_count -ne 0 ]; then
  echo "CppCheck found ${errors_count} errors."
  while read_dom; do
    if [[ $ENTITY -eq "error" ]]; then
        echo $CONTENT
    fi
  done < $cppcheck_file
  exit 1
else
  echo "CppCheck found no errors"
  exit 0
fi
