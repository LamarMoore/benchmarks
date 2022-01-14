# Mark build as passed or failed. The additional "|| true" stops the build from failing if there are no errors.
read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
}

errors_count=$(grep -c '</error>' ./build/cppcheck.xml) || true
if [ $errors_count -ne 0 ]; then
  echo "CppCheck found ${errors_count} errors."
  while read_dom; do
    if [[ $ENTITY -eq "error" ]]; then
        echo $CONTENT
    fi
  done < ./build/cppcheck.xml
  exit 1
else
  echo "CppCheck found no errors"
  exit 0
fi
