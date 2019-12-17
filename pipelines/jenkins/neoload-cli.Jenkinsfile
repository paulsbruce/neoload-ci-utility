pipeline {
  agent none

  //environment { // either set these in 'prepare...' or get from a secrets provider
    //NLW_TOKEN = 'YOUR NLWEB TOKEN'
    //NLW_ZONE = 'ZONE ID'
  //}

  stages {
    stage('Grab Utility Repo') {
      agent { label 'master' }
      steps {
        cleanWs()
        dir('utility') {
            git(branch: "master", url: 'https://github.com/paulsbruce/neoload-ci-utility.git')
        }
        dir('nl_project') {
            git(branch: "master", url: 'https://github.com/Neotys-Labs/neoload-cli.git')
        }
      }
    }
    stage('Attach Worker') {
      agent {
        dockerfile { // load python container
          args "--user root --rm -v /var/run/docker.sock:/var/run/docker.sock"
          dir 'utility/docker/dind-python3'
        }
      }
      stages {
        stage('Get NeoLoad CLI') {
          steps {
              script {
                  sh 'python3 -m pip install neoload==0.3.2'
                  //sh "python3 -m pip install -q -e nl_project/"
              }
          }
        }
        stage('Init Profile') {
          steps {
              script {
                  sh "neoload --profile temp --token $NLW_TOKEN --zone $DOCKER_NLW_ZONE"
              }
          }
        }
        stage('Run Test') {
          steps {
              script {
                  sh """\
                     PYTHONUNBUFFERED=1 \
                     neoload \
                     --scenario sanityScenario \
                     --attach docker#2,neotys/neoload-loadgenerator:6.10 \
                     -f nl_project/tests/example_2_0_runtime/default.yaml \
                    """/*
                     -f nl_project/tests/example_2_0_runtime/slas/uat.yaml \
                    """*/
              }
          }
        }
      }
    }
  }
}
