# Mark build as passed or failed. The additional "|| true" stops the build from failing if there are no errors.
errors_count=$(grep -c '</error>' ./build/cppcheck.xml) || true
if [ $errors_count -ne 0 ]; then
  echo "CppCheck found ${errors_count} errors."
  echo "See CppCheck link on the job page for more detail, or adjust the count."
  exit 1
else
  echo "CppCheck found no errors"
  exit 0
fi
