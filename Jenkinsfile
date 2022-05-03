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
	    
	     stage('Build image') {
               steps {
                 sh 'docker build -t sriram226/ci-cd:$BUILD_NUMBER .'
                
            }
        }
                stage('push docker image') {
			steps {
				withCredentials([string(credentialsId: 'DOCKER_HUB_PWD', variable: 'DOCKER_HUB_PWD')]) {
                sh "docker login -u sriram226 -p ${DOCKER_HUB_PWD}"
				}
				sh 'docker push sriram226/ci-cd:$BUILD_NUMBER'
			}
        }
        stage('Deploy to K8s') {
			steps {
				sh 'chmod 755 changetag.sh'
                                sh './changetag.sh $BUILD_NUMBER'
				sh 'kubectl apply -f deploy/sampleapp-deploy-k8.yml'
			}
        }
	    
	    
    }
}
