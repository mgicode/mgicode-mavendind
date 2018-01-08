# mgicode-mavendind
 把Maven的docker和dind的docker合两为一，解决jenkins的pipeline编写的脚本重复及丑陋的问题
 
 ##采用mgicode-mavendind之前pipeline
 
 ```
 
pipeline {
    agent none
    stages {

        stage('git') {
             agent {
                    docker {
                         image '10.1.12.61:5000/maven'
                         args '-v /root/.m2:/root/.m2'
                         }
               }
            steps {
                git branch: 'master', credentialsId: '0a2f41d3-8b08-4c3c-b962-2444ae0fbb22', url: 'http://10.1.12.92/pengrk/simple-java-maven-app-master.git'

            }
        }
        stage('Build') {
            agent {
                    docker {
                        image '10.1.12.61:5000/maven'
                        args '-v /root/.m2:/root/.m2'
                    }

                }
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            agent {
                docker {
                    image '10.1.12.61:5000/maven'
                    args '-v /root/.m2:/root/.m2'
                }

            }
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }


       stage('StaticCheck') {
            agent {
                    docker {
                        image '10.1.12.61:5000/maven'
                        args '-v /root/.m2:/root/.m2'
                    }

                }
            steps {
                sh ' mvn sonar:sonar  -Dsonar.host.url=http://10.1.12.90:9000 -Dsonar.login=277a6a58a4ae62ab3cb9785a7dec54e719767597'
            }
            post {
               always {
                  junit 'target/surefire-reports/*.xml'
                     }
               }
       }

       //找不到上面构建的jar
       stage('buildDocker') {

           agent {
               docker {
                   image '10.1.12.61:5000/jpetazzo/dind'
               }
           }
           steps {
                sh ' chmod 777 ./jenkins/scripts/dockerbuild.sh ; ./jenkins/scripts/dockerbuild.sh'
                }
            }
    }
}


 
 ```
 
 
  ##采用mgicode-mavendind之后pipeline
  
  ```
  pipeline {
      agent {
          docker {
              image '10.1.12.61:5000/mavendind'
              args '-v /root/.m2:/root/.m2'
          }
      }
      stages {
          stage('git') {
              steps {
                  git branch: 'master', credentialsId: '0a2f41d3-8b08-4c3c-b962-2444ae0fbb22', url: 'http://10.1.12.92/pengrk/simple-java-maven-app-master.git'
  
              }
          }
          stage('Build') {
              steps {
                  sh 'mvn -B -DskipTests clean package'
              }
          }
          stage('Test') {
              steps {
                  sh 'mvn test'
              }
              post {
                  always {
                      junit 'target/surefire-reports/*.xml'
                  }
              }
          }
  
          stage('StaticCheck') {
              steps {
                  sh ' mvn sonar:sonar  -Dsonar.host.url=http://10.1.12.90:9000 -Dsonar.login=277a6a58a4ae62ab3cb9785a7dec54e719767597'
              }
              post {
                  always {
                      junit 'target/surefire-reports/*.xml'
                  }
              }
          }
  
          stage('buildDocker') {
              steps {
                  sh ' chmod 777 ./jenkins/scripts/dockerbuild.sh ; ./jenkins/scripts/dockerbuild.sh "10.1.12.61:5000"'
              }
          }
      }
  }
  
```

可以看出对于多docker容器编译处理的话，其代码很丑陋，很多重复的代码，更不用说每次都要拉镜像并启动该docker,浪费时间 。

 ##自己编译运行
 
 1、先下载当前项目，解压，命令行进入其根目录，运行（前提得安装docker）
 ```
docker build -t mavendind  -f Dockerfile  $(pwd)
```
2、运行，
 ```
docker run -d --name mavendind  mavendind
```
3、进行容器中运行 mvn 和docker，看看是否成功
 ```
docker exec -it mavendind /bin/bash
```

## 下载docker镜像直接使用
 ```
docker pull registry.cn-hangzhou.aliyuncs.com/prk/mgicode-mavendind:1.0
 ```
 
 ## 下一步工作
 
 目前其maven和docker分别是maven3.5,open-jdk1.8 和docker17.09，其操作系统采用是debian，
 下一步改成centos  oracle jdk