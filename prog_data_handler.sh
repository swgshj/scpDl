#!/bin/bash
echo "`date` start process prognostic data file[$1]..."

java -jar progDataParser.jar $1 tcp://127.0.0.1:1883 2

echo "`date` end process prognostic data file[$1]."

