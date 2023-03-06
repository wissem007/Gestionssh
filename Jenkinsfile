pipeline {
    
    
    
    agent any
   
    tools {
        maven "Maven"
    }
    environment {
        
        project = 'ges' 
        imageVersion = 'v' 
        imageTag = "wissem007/${project}:${imageVersion}.${env.BUILD_NUMBER}" 
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "141.95.254.226:8081"
        NEXUS_REPOSITORY = "maven-nexus-repo"
        NEXUS_CREDENTIAL_ID = "nexus-user-credentials"
    }
    stages {
        stage("Clone code from VCS") {
            steps {
                script {
                    git 'https://github.com/wissem007/Gestion.git';
                }
            }
        }
        stage("Maven Build") {
            steps {
                script {
                   //sh "mvn package -DskipTests=true"
                   sh "mvn -Dmaven.test.failure.igonre=true clean package"
                   //sh "mvn clean package"
                }
            }
        }  
        stage('SonarQube analysis') {
            steps {
             script {
             withSonarQubeEnv('SonarQube') {
         sh 'mvn clean package sonar:sonar'
      }
    }
  }
}   

        stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
        
        stage("Docker Image File"){
            steps {
                script {
      sh '''rm -rf /var/jenkins_home/workspace/PipelineNSD/dockerimages
cd /var/lib/jenkins/workspace/PipelineNSD/dockerimages
cp /var/lib/jenkins/workspace/PipelineNSD/target/Gestion.war .
touch dockerfile
cat <<EOT>> dockerfile
FROM tomcat:8-jre8                          
# MAINTAINER                                
MAINTAINER "Wissem"                         
# COPY WAR FILE ON TO Contaire              
COPY ./Gestion.war /usr/local/tomcat/webapps
CMD ["catalina.sh", "run"]
EXPOSE 8080
EOT'''
              }
          }
        }
        stage("Build Docker Image"){
            steps {
                script {
                    sh '''cd /var/lib/jenkins/workspace/PipelineNSD/dockerimages
docker build -t ${imageTag} .''' 
      
              }
          }
        }
          stage("Docker Push"){
            steps {
                script {
                     withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh "docker push ${imageTag}"
        }
          
      
              }
          }
        }
        
        stage('Cleaning up') {
             steps {
                script {
    
        sh "docker rmi ${imageTag}"
                       }
                 
                   }
             
        }
        
         stage('Docker RUN') {
             steps {
                script {
        sh "docker rm -f Gestion "
        sh "docker run -itd --name Gestion -p 8888:8080 ${imageTag}"
                       }
                 
                   }
             
        }
        
      
    }
        
        
        
}

