node{
    
    def project = 'gestion' 
    def imageVersion = 'development' 
    def imageTag = "wissem007/${project}:${imageVersion}.${env.BUILD_NUMBER}" 
      environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "178.33.44.117:8081/"
        NEXUS_REPOSITORY = "maven-nexus-repo"
        NEXUS_CREDENTIAL_ID = "nexus-user-credentials"
    }
    
    stage("Git Clone"){
        git 'https://github.com/wissem007/Gestion.git'
    }
    
    stage("Maven Clean Build"){
        sh "mvn package -DskipTests=true"
       
    }
     


    stage("SonarQube analysis") {
            
            def scannerHome = tool 'sonarqube';
			withSonarQubeEnv('sonarqube') {
			sh "${scannerHome}/bin/sonar-scanner \
			-D sonar.login=admin \
			-D sonar.password=admin123 \
			-D sonar.projectKey=Gestion  \
			-D sonar.exclusions=vendor/**,resources/**,**/*.java \
			-D sonar.host.url=http://178.33.44.117:7000"
                }
               timeout(time: 1, unit: 'HOURS') {
                      def qg = waitForQualityGate()
                      if (qg.status != 'OK') {
                           error "Pipeline aborted due to quality gate failure: ${qg.status}"
                      }
                    }
            }
         
       
    
    stage("Build Docker Image"){
        
        sh "cp /var/lib/jenkins/workspace/pipeline_pushimage/target/Gestion.war /opt/docker/"
        sh "docker build -t ${imageTag} /opt/docker"
      
    }
    
   stage("Docker Push"){
        
        withCredentials([usernamePassword(credentialsId: 'dockerhub_id', passwordVariable: 'dockerHubPassword', usernameVariable:       'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh "docker push ${imageTag}"
        }
        
        
     
      stage('Cleaning up') {
    
        sh "docker rmi -f ${imageTag}"
    } 

      stage("Remove Docker Container"){
         
        sh "docker stop gestion "
        sh "docker rm -f gestion "
      
    }
     stage("Run Docker Image"){
         
        sh "docker run -d --name gestion -p 5555:8080 ${imageTag} "
      
    } 
         
   } 
  
 }   
