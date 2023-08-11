import 'package:flutter/material.dart';
import 'package:meu_flash/services/gpt_services/gpt_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<MessageBubble> messageBubbles = [];
  final TextEditingController textEditingController = TextEditingController();
  final gptService = GptService();
  bool isWriting = false;

  @override
  void initState() {
    super.initState();
    adicionarMensagemDeBoasVindas();
  }

  void adicionarMensagemDeBoasVindas() {
    final mensagemBoasVindas =
        "Olá! Eu sou o Syn, seu assistente de aprendizagem médica. Sinta-se à vontade para me fazer qualquer pergunta relacionada à área médica.";
    setState(() {
      messageBubbles.add(MessageBubble(
        sender: ' ',
        text: mensagemBoasVindas,
        imageUrl: 'lib/assets/bot.jpg',
        isMe: false,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            reverse: true,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: messageBubbles.length,
              itemBuilder: (context, index) {
                return messageBubbles[index];
              },
            ),
          ),
          if (isWriting)
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  'lib/assets/typing.gif',
                  height: 30,
                  width: 300,
                ),
              ),
            )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 56,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  padding: EdgeInsets.only(left: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem aqui...',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                    maxLines: 2,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final userMessage = textEditingController.text;
                      setState(() {
                        messageBubbles.add(MessageBubble(
                          sender: ' ',
                          text: userMessage,
                          imageUrl: 'lib/assets/user_profile.png',
                          isMe: true,
                        ));
                        isWriting = true;
                      });
                      textEditingController.clear();

                      final messages = [
                        {'role': 'system', 'content': 'Você é um assistente útil.'},
                        {'role': 'user', 'content': userMessage},
                      ];

                      try {
                        final botResponse = await gptService.generateResponse(messages);

                        setState(() {
                          messageBubbles.add(MessageBubble(
                            sender: ' ',
                            text: botResponse,
                            imageUrl: 'lib/assets/bot.jpg',
                            isMe: false,
                          ));
                          isWriting = false;
                        });
                      } catch (e) {
                        print('Erro: $e');
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      child: FittedBox( // Wrap the Text widget with FittedBox
                        fit: BoxFit.scaleDown, // Choose how the text should fit within the box
                        child: Text(
                          'Enviar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String imageUrl;

  MessageBubble({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(imageUrl),
              ),
            ),
          Flexible( // Adicionado para evitar o corte do texto
            child: Column(
              crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  sender,
                  style: TextStyle(color: Colors.white),
                ),
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 5.0,
                  color: isMe ? Colors.white : Colors.grey.shade200,
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isMe ? Colors.black : Colors.black87,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe)
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(imageUrl),
              ),
            ),
        ],
      ),
    );
  }
}
