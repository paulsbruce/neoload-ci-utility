pipeline {
  agent none

  environment { // either set these in 'prepare...' or get from a secrets provider
    //NLW_TOKEN = 'YOUR NLWEB TOKEN'
    //NLW_ZONE = 'ZONE ID'
  }

  stages {
    stage('Grab Utility Repo') {
      agent { label 'master' }
      steps {
        cleanWs()
        dir('utility') {
            git(branch: "DockerPython3", url: 'https://github.com/paulsbruce/neoload-ci-utility.git')
        }
        dir('nl_project') {
            git(branch: "JenkinsExamples", url: 'https://github.com/Neotys-Labs/neoload-cli.git')
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
                  //sh 'python3 -m pip --no-cache-dir install -i https://pypi.org/simple  --allow-external neoload==0.2'
                  sh "python3 -m pip install -q -e nl_project/"
                  sh "export PYTHONUNBUFFERED=1"
              }
          }
        }
        stage('Init Profile') {
          steps {
              script {
                  sh "neoload --debug --profile openshift --token $NLW_TOKEN --zone $NLW_ZONE"
              }
          }
        }
        stage('Run Test') {
          steps {
              script {
                  sh """\
                     PYTHONUNBUFFERED=1 \
                     neoload --debug \
                    -f nl_project/tests/example_2_0_runtime/default.yaml \
                    -f nl_project/tests/example_2_0_runtime/slas/uat.yaml \
                    --scenario sanityScenario \
                    """
              }
          }
        }
      }
    }
  }
}
