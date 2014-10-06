shopt -s extglob

[ $(uname) == "Darwin" ] && SED_FLAG='-l' || SED_FLAG='-u'


# Syntax sugar.
indent() {
  RE="s/^/       /"
  sed $SED_FLAG "$RE"
}


# Buildpack Steps.
function puts () {
  echo "       $@"
}

function puts-step (){
  echo "-----> $@"
}

# Buildpack Warnings.
function puts-warn (){
  echo " !     $@"
}

# Usage: $ set-env key value
function set-env (){
  echo "export $1=$2"
}

# Usage: $ set-default-env key value
function set-default-env (){
  echo "export $1=\${$1:-$2}"
}

# Usage: $ set-default-env key value
function un-set-env (){
  echo "unset $1"
}

# Does some serious copying.
function deep-cp (){
  find -H $1 -maxdepth 1 -name '.*' -a \( -type d -o -type f -o -type l \) -exec cp -a '{}' $2 \;
  cp -r $1/!(tmp) $2
  # echo copying $1 to $2
}

# Does some serious moving.
function deep-mv (){
  deep-cp $1 $2

  rm -fr $1/!(tmp)
  find -H $1 -maxdepth 1 -name '.*' -a \( -type d -o -type f -o -type l \) -exec rm -fr '{}' \;
}

# Does some serious deleting.
function deep-rm (){
  rm -fr $1/!(tmp)
  find -H $1 -maxdepth 1 -name '.*' -a \( -type d -o -type f -o -type l \) -exec rm -fr '{}' \;
}