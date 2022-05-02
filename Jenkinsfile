pipeline {
    agent any
    stages {
        stage('compile') {
	   steps {
                echo 'compiling..'
		git url: 'https://github.com/sriram226/samplejavaapp'
		sh script: '/opt/apache-maven-3.8.5/bin/mvn compile'
           }
        }
       
        stage('unit-test') {
	   steps {
                echo 'unittest..'
	        sh script: '/opt/apache-maven-3.8.5/bin/mvn test'
                 }
	   post {
               success {
                   junit 'target/surefire-reports/*.xml'
               }
           }			
        }
        stage('codecoverate') {
	   steps {
                echo 'codecoverage..'
		sh script: '/opt/apache-maven-3.8.5/bin/mvn cobertura:cobertura -Dcobertura.report.format=xml'
           }
	   post {
               success {
	           cobertura autoUpdateHealth: false, autoUpdateStability: false, coberturaReportFile: 'target/site/cobertura/coverage.xml', conditionalCoverageTargets: '70, 0, 0', failUnhealthy: false, failUnstable: false, lineCoverageTargets: '80, 0, 0', maxNumberOfBuilds: 0, methodCoverageTargets: '80, 0, 0', onlyStable: false, sourceEncoding: 'ASCII', zoomCoverageChart: false                  
               }
           }		
        }
        stage('package') {
	   steps {
                echo 'package......'
		sh script: '/opt/apache-maven-3.8.5/bin/mvn package'	
           }		
        }
	    
	     stage("Build image") {
            steps {
                script {
                    myapp = docker.build("sriram226/ci-cd:${env.BUILD_ID}")
                }
            }
        }
    
      stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                            myapp.push("latest")
                            myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }

    
    stage('Deploy App') {
      steps {
        script {
          kubernetesDeploy(configs: "hellowhale.yml", kubeconfigId: "mykubeconfig")
        }
      }
    }
    }
}
