## iAnime 简易移动端线稿上色软件

### 仓库简介

您正在看到的是iOS端的源代码仓库。当前最新版本的iOS客户端代码就放置在这个仓库中。

与此同时，这个仓库中还包含了本次课程作业答辩的相关文档，以及课程报告文档。这些文档放置在``Documents``文件夹中。

除此之外，iAnime还具有后端业务层代码以及上色节点相关的代码，它们分别放置在以下仓库中

[iAnime 后端业务代码](https://github.com/iosTeamofFour/iAnimeServer.js)

[iAnime 上色节点代码](https://github.com/iosTeamofFour/iAnimeColorization)

**注意事项:**

1. 后端和上色节点之间是采用消息队列来通信的。因此除了部署后端业务代码和上色节点代码以外，还需要启动一个RabbitMQ消息队列供它们之间通信。以下给出在Ubuntu上以Docker方式运行消息队列的指令:

   ```shell
   sudo docker run -d --hostname my-rabbit -p 4369:4369 -p 5671:5671 -p 5672:5672 -p 15671:15671 -p 15672:15672 -p 25672:25672 --name some-rabbit rabbitmq:3-management
   ```

   

