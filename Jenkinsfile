podTemplate(
    // 之前配置的 Kubernetes Cloud Provider
    cloud:"k8s",
    // 这个 pipeline 执行环境名称
    name: "go-demo",
    // 运行在带有 always-golang 标签的 Jenkins Slave 上 
    label: 'always-golang', 
    // 最多同时只运行 1 个作业
    instanceCap: 1,
    containers: [
        // Kubernetes Pod 的配置, 这个 Pod 包含两个容器
        containerTemplate(
            name: 'jnlp', 
            alwaysPullImage: true,
            // Jenkins Slave ， 与 Master 通信进程
            image: 'cargo.caicloud.io/circle/jnlp:2.62',
            command: "", 
            args: '${computer.jnlpmac} ${computer.name}',
            resourceRequestCpu: '500m',
            resourceLimitCpu: '1000m',
            resourceRequestMemory: '500Mi',
            resourceLimitMemory: '1000Mi',
        ),
        containerTemplate(
            name: 'dind', 
            // Jenkins Slave 作业执行环境， 此处为一个 Docker in Docker 环境，用于跑作业
            image: 'cargo.caicloud.io/caicloud/docker:1.11-dind', 
            ttyEnabled: true, 
            command: "", 
            args: "",
            privileged: true,
            resourceRequestCpu: '500m',
            resourceLimitCpu: '1000m',
            resourceRequestMemory: '500Mi',
            resourceLimitMemory: '1000Mi',
        )
    ]
)
// 此 Jenkins pipeline 流水线任务需要运行在带有 always-golang 标签的 Jenkins node 环境内
// 此处需要了解的是，node 名称的不带 always 标签的 pod 在执行完当次的持续流水线后会退出。而有 always 开头标签的 pod 环境是会本次持续流水线后持续运行，等待运行下次需要相同标签 Jenkins Slave Node 环境的作业，以节省环境创建时间及之前拉取过的 Docker 镜像
{
    node("always-golang") {
        // 定义每个 stage 的作业内容  
        // clone 代码      
        stage('clone') {
            git(url: 'https://github.com/zoumo/go-demo.git', branch: 'master')
        }
        // 编译代码
        stage("PreBuild"){
            docker.image('cargo.caicloud.io/caicloud/golang:1.7.5-alpine').inside {
                sh '''
                    mkdir -p /go/src/github.com/zoumo
                    ln -s $(pwd) /go/src/github.com/zoumo/go-demo
                    cd /go/src/github.com/zoumo/go-demo
                    go test .
                    go build -o cyclone .
                '''
            }
        }
        // 构建 Docker 镜像
        stage('Build') {
            docker.build("circle/integration")
        }
        // 运行集成测试用例
        stage('Integration') {
            docker.image("circle/integration").run()
        }
        // 推送镜像至镜像仓库
        stage("Publish") {
            docker.withRegistry("https://cargo.caicloud.io", "cargo-circle") {
                docker.image("circle/integration").push()
            }
        }
        // 发布最新的应用到 Kubernetes        
        // stage("deploy") {
        //     sh """
        //     kubectl config  set-cluster default --server="https://circle-dev.caicloudprivatetest.com"
        //     kubectl config  set-credentials default --token="\$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
        //     kubectl config set-context default --namespace "\$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)" --cluster default --user default && kubectl config use-context default

        //     kubectl get deployment nginx -o yaml | sed 's/(image: nginx):.*\$/\\1:1.11-alpine/' | kubectl replace -f -
  
        //     """
        // }
    }
}
