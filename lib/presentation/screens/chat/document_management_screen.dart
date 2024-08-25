import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/document/document_bloc.dart';
import '../../widgets/document_card.dart';

class DocumentManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Documents'),
      ),
      body: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          if (state is DocumentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DocumentLoaded) {
            return ListView.builder(
              itemCount: state.documents.length,
              itemBuilder: (context, index) {
                final document = state.documents[index];
                return DocumentCard(document: document);
              },
            );
          } else if (state is DocumentError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Aucun document disponible.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logique pour ajouter un nouveau document
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
