#!/usr/bin/env bash
function iskeyword {
   awk 'BEGIN{f="c11";while(getline<f)k[$1]=0}
	{if($1 in k)k[$1]++}END{for(i in k)print k[i],i}'
}
cat "$@" | ./prog -t | iskeyword | sort -k1nr
