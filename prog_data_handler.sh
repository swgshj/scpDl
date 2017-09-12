#!/bin/bash
echo "`date` start process prognostic data file[$1] from [$2]..."

topicPrefix="$2-"
java -jar progDataParser.jar $1 tcp://127.0.0.1:18830 2 $topicPrefix

echo "`date` end process prognostic data file[$1]."

